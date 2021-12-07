package users

import (
	"context"
	"errors"
	"log"
	"time"
	"time-tracker/src/clients"
	"time-tracker/src/database"
	shared "time-tracker/src/shared"

	"github.com/kpango/glg"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"golang.org/x/crypto/bcrypt"
)

type Worklog struct {
	ID          string `bson:"_id,omitempty" json:"id"`
	ProjectId   string `bson:"project_id" json:"project_id"`
	Hours       int    `bson:"hours" json:"hours"`
	Description string `bson:"description" json:"description"`
}

type User struct {
	ID        string            `bson:"_id,omitempty" json:"id"`
	Username  string            `bson:"user_name" json:"user_name"`
	FirstName string            `bson:"first_name" json:"first_name"`
	Email     string            `bson:"email" json:"email"`
	Password  string            `bson:"password" json:"password"`
	CreatedAt time.Time         `bson:"created_at,omitempty" json:"created_at"`
	UpdatedAt time.Time         `bson:"updated_at,omitempty" json:"updated_at"`
	Projects  []clients.Project `bson:"projects" json:"projects"`
}

func GetUserWorklog(id string) ([]Worklog, error) {
	user, err := GetUserById(id)
	if err != nil {
		return nil, errors.New("user not found")
	}
	worklogCollection, err := database.GetMongoCollection(database.WORKLOGS)
	if err != nil {
		return nil, err
	}

	cursor, err := worklogCollection.Find(context.TODO(), bson.M{"user_id": user.ID}, options.Find())
	if err != nil {
		glg.Error(err)
	}
	var worklogs []Worklog
	err = cursor.All(context.TODO(), &worklogs)
	if err != nil {
		glg.Error(err)
		return make([]Worklog, 0), err
	}
	if len(worklogs) == 0 {
		return make([]Worklog, 0), nil
	}
	return worklogs, nil

}

func AddUserWorklog(id string, worklog Worklog) error {
	project, err := clients.GetProjectById(worklog.ProjectId)
	if err != nil {
		return errors.New("project not found")
	}
	user, err := GetUserById(id)
	if err != nil {
		return errors.New("user not found")
	}

	worklogCollection, err := database.GetMongoCollection(database.WORKLOGS)
	if err != nil {
		return err
	}
	_, err = worklogCollection.InsertOne(context.TODO(), bson.M{
		"user_id":     user.ID,
		"project_id":  project.ID,
		"hours":       worklog.Hours,
		"description": worklog.Description,
		"created_at":  time.Now(),
		"updated_at":  time.Now(),
	})
	if err != nil {
		glg.Error(err)
		return err
	}
	return nil
}

func AddUserProject(id string, project clients.Project) error {
	project, err := clients.GetProjectById(project.ID)
	if err != nil {
		return errors.New("project not found")
	}

	user, err := GetUserById(id)
	if err != nil {
		return errors.New("user not found")
	}
	for _, v := range user.Projects {
		if v.ID == project.ID {
			return errors.New("project already exists")
		}
	}
	userCollection, err := database.GetMongoCollection(database.USERS)
	if err != nil {
		return err
	}
	objectId, err := primitive.ObjectIDFromHex(user.ID)
	if err != nil {
		return errors.New("invalid id")
	}
	data, err := shared.ToDoc(project)
	if err != nil {
		return err
	}
	_, err = userCollection.UpdateOne(
		context.TODO(),
		bson.M{"_id": objectId},
		bson.D{
			{"$addToSet", bson.M{"projects": data}},
		},
	)
	if err != nil {
		log.Fatal(err)
	}
	return nil
}

func GetUsers() ([]User, error) {
	collection, err := database.GetMongoCollection(database.USERS)
	if err != nil {
		return nil, err
	}
	projection := bson.D{
		{"password", 0},
	}
	cursor, err := collection.Find(context.TODO(), bson.D{}, options.Find().SetProjection(projection))
	if err != nil {
		glg.Error(err)
	}
	var users []User
	err = cursor.All(context.TODO(), &users)
	if err != nil {
		glg.Error(err)
		return make([]User, 0), err
	}
	if len(users) == 0 {
		return make([]User, 0), nil
	}
	return users, nil
}

func GetUserById(id string) (user User, err error) {
	collection, err := database.GetMongoCollection(database.USERS)
	if err != nil {
		return User{}, err
	}
	objectId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return User{}, errors.New("invalid id")
	}
	projection := bson.D{{"password", 0}}
	err = collection.FindOne(context.TODO(), bson.M{"_id": objectId}, options.FindOne().SetProjection(projection)).Decode(&user)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			// This error means your query did not match any documents.
			return user, errors.New("user not found")
		}
		glg.Error(err)
		return User{}, err
	}
	return user, nil
}

func FindUserByEmail(email string) (User, error) {
	//Get MongoDB connection using connectionhelper.
	client, err := database.GetMongoClient()
	if err != nil {
		return User{}, err
	}
	collection := client.Database(database.DB).Collection(database.USERS)
	var user User
	filter := bson.D{primitive.E{Key: "email", Value: email}}
	err = collection.FindOne(context.TODO(), filter).Decode(&user)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			// This error means your query did not match any documents.
			return User{}, nil
		}
		glg.Error(err)
		return User{}, err
	}
	return user, nil
}

func CreateUser(user User) (interface{}, error) {
	exitingUser, err := FindUserByEmail(user.Email)
	if err != nil {
		return nil, err
	}
	if exitingUser.ID != "" {
		return nil, errors.New("User already exists")
	}

	//Get MongoDB connection using connectionhelper.
	mclient, err := database.GetMongoClient()
	if err != nil {
		return nil, err
	}
	collection := mclient.Database(database.DB).Collection(database.USERS)

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)

	if err != nil {
		glg.Error(err)
		return nil, err
	}

	inserted, err := collection.InsertOne(context.TODO(), bson.M{
		"user_name":  user.Username,
		"email":      user.Email,
		"password":   string(hashedPassword),
		"created_at": time.Now(),
		"updated_at": time.Now(),
	})
	if err != nil {
		glg.Error(err)
		return nil, err
	}
	//Return success without any error.
	return inserted.InsertedID, nil
}

func DeleteUserById(id string) error {
	//Get MongoDB connection using connectionhelper.
	client, err := database.GetMongoClient()
	if err != nil {
		return err
	}
	collection := client.Database(database.DB).Collection(database.USERS)
	objectId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return errors.New("invalid id")
	}
	_, err = collection.DeleteOne(context.TODO(), bson.M{"_id": objectId})
	if err != nil {

		glg.Error(err)
		return err
	}
	return nil
}
