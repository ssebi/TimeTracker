package users

import (
	"context"
	"time"
	"time-tracker/src/database"

	"github.com/kpango/glg"
	"go.mongodb.org/mongo-driver/bson"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID        string    `bson:"_id,omitempty" json:"id"`
	Username  string    `bson:"user_name" json:"user_name"`
	Email     string    `bson:"email" json:"email"`
	Password  string    `bson:"password" json:"password"`
	CreatedAt time.Time `bson:"created_at,omitempty" json:"created_at"`
	UpdatedAt time.Time `bson:"created_at,omitempty" json:"updated_at"`
}

func saveUser(user User) (interface{}, error) {
	user.ID = user.Email
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		glg.Error(err)
		panic(err)
	}
	//Get MongoDB connection using connectionhelper.
	client, err := database.GetMongoClient()
	if err != nil {
		return nil, err
	}
	collection := client.Database(database.DB).Collection(database.USERS)
	inserted, err := collection.InsertOne(context.TODO(), bson.M{
		"_id":        user.ID,
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
