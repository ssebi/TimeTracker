package clients

import (
	"context"
	"errors"
	"time"
	"time-tracker/src/database"

	"github.com/kpango/glg"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Project struct {
	ID        string    `bson:"_id,omitempty" json:"id"`
	Name      string    `bson:"name" json:"name"`
	CreatedAt time.Time `bson:"created_at,omitempty" json:"created_at"`
	UpdatedAt time.Time `bson:"updated_at,omitempty" json:"updated_at"`
}

type Client struct {
	ID        string    `bson:"_id,omitempty" json:"id"`
	Name      string    `bson:"name" json:"name"`
	Projects  []Project `bson:"projects" json:"projects"`
	CreatedAt time.Time `bson:"created_at,omitempty" json:"created_at"`
	UpdatedAt time.Time `bson:"updated_at,omitempty" json:"updated_at"`
}

func GetAllClients() (clients []Client, err error) {
	collection, err := database.GetMongoCollection(database.CLIENTS)
	if err != nil {
		return nil, err
	}
	cursor, err := collection.Find(context.TODO(), bson.M{})
	if err != nil {
		glg.Error(err)
	}
	err = cursor.All(context.TODO(), &clients)
	if err != nil {
		glg.Error(err)
		return make([]Client, 0), err
	}
	if len(clients) == 0 {
		return make([]Client, 0), nil
	}
	return clients, nil
}

func GetProjectById(id string) (Project, error) {
	collection, err := database.GetMongoCollection(database.CLIENTS)
	if err != nil {
		return Project{}, err
	}

	objectId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return Project{}, errors.New("invalid id")
	}

	var client Client
	filter := bson.M{
		"projects": bson.M{
			"$elemMatch": bson.M{"_id": objectId},
		},
	}

	err = collection.FindOne(context.TODO(), filter).Decode(&client)
	if err != nil {
		return Project{}, err
	}

	var project Project
	for _, v := range client.Projects {
		if v.ID == id {
			project = v
		}
	}
	return project, nil
}

func SaveClient(client Client) (interface{}, error) {
	insertableProjects := make([]interface{}, len(client.Projects))
	for i, v := range client.Projects {
		insertableProjects[i] = bson.M{
			"_id":        primitive.NewObjectID(),
			"name":       v.Name,
			"created_at": time.Now(),
			"updated_at": time.Now(),
		}
	}

	collection, err := database.GetMongoCollection(database.CLIENTS)
	if err != nil {
		return nil, err
	}
	inserted, err := collection.InsertOne(context.TODO(), bson.M{
		"name":       client.Name,
		"projects":   insertableProjects,
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
