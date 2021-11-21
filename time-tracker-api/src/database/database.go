package database

import (
	"context"
	"sync"
	"time-tracker/src/shared"

	"github.com/kpango/glg"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

/* Used to create a singleton object of MongoDB client.
Initialized and exposed through  GetMongoClient().*/
var clientInstance *mongo.Client

//Used during creation of singleton client object in GetMongoClient().
var clientInstanceError error

//Used to execute client creation procedure only once.
var mongoOnce sync.Once

//I have used below constants just to hold required database config's.
const (
	DB       = "timetracker"
	USERS    = "col_users"
	CLIENTS  = "col_clients"
	WORKLOGS = "col_worklogs"
)

//GetMongoClient - Return mongodb connection to work with
func GetMongoClient() (*mongo.Client, error) {
	//Perform connection creation operation only once.
	mongoOnce.Do(func() {
		// Set client options
		CONNECTIONSTRING := shared.GoDotEnvVariable("MONGO_URL")
		clientOptions := options.Client().ApplyURI(CONNECTIONSTRING)
		// Connect to MongoDB
		client, err := mongo.Connect(context.TODO(), clientOptions)
		if err != nil {
			clientInstanceError = err
		}
		// Check the connection
		err = client.Ping(context.TODO(), nil)
		if err != nil {
			clientInstanceError = err
		}
		clientInstance = client
	})
	return clientInstance, clientInstanceError
}

func GetMongoCollection(col string) (*mongo.Collection, error) {
	client, err := GetMongoClient()
	if err != nil {
		glg.Error(err)
		return nil, err
	}
	collection := client.Database(DB).Collection(col)
	return collection, nil
}
