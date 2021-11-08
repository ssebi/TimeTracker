package users

import (
	"time"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID        primitive.ObjectID `bson:"_id" json:"id"`
	Username  string             `bson:"user_name" json:"user_name"`
	Email     string             `bson:"email" json:"email"`
	Password  string             `bson:"password" json:"password"`
	CreatedAt time.Time          `bson:"created_at" json:"created_at"`
	UpdatedAt time.Time          `bson:"created_at" json:"updated_at"`
}

func RegisterUsersController(api *gin.RouterGroup) {
	api.GET("/users", GetUsers)
	api.GET("/users/:id", GetUser)
	api.POST("/users", CreateUser)
	api.PUT("/users/:id", UpdateUser)
	api.DELETE("/users/:id", DeleteUser)
}

// @Tags users
// @Produce json
// @Success 200
// @Router /users [get]
func GetUsers(c *gin.Context) {

}

// @Tags users
// @Produce json
// @Success 200
// @Router /users/:id [get]
func GetUser(c *gin.Context) {

}

func CreateUser(c *gin.Context) {

}

func UpdateUser(c *gin.Context) {}

func DeleteUser(c *gin.Context) {}
