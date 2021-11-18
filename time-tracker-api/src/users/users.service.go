package users

import (
	"context"
	"errors"
	"time"
	"time-tracker/src/database"

	"github.com/kpango/glg"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID        string    `bson:"_id,omitempty" json:"id"`
	Username  string    `bson:"user_name" json:"user_name"`
	Email     string    `bson:"email" json:"email"`
	Password  string    `bson:"password" json:"password"`
	CreatedAt time.Time `bson:"created_at,omitempty" json:"created_at"`
	UpdatedAt time.Time `bson:"updated_at,omitempty" json:"updated_at"`
}

func GetAllUsers() ([]User, error) {
	//Get MongoDB connection using connectionhelper.
	client, err := database.GetMongoClient()
	if err != nil {
		return nil, err
	}
	collection := client.Database(database.DB).Collection(database.USERS)
	cursor, err := collection.Find(context.TODO(), bson.M{})
	if err != nil {
		glg.Error(err)
	}
	var users []User
	err = cursor.All(context.TODO(), &users)
	if err != nil || len(users) == 0 {
		glg.Error(err)
		return make([]User, 0), err
	}
	return users, nil
}

func GetUserById(id string) (User, error) {
	//Get MongoDB connection using connectionhelper.
	client, err := database.GetMongoClient()
	if err != nil {
		return User{}, err
	}
	collection := client.Database(database.DB).Collection(database.USERS)
	objectId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return User{}, errors.New("invalid id")
	}
	var user User
	err = collection.FindOne(context.TODO(), bson.M{"_id": objectId}).Decode(&user)
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

func SaveUser(user User) (interface{}, error) {
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
