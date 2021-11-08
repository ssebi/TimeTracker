package users

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

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

// @Tags users
// @Produce json
// Description Create User
// @Success 200
// @Router /users [post]
func CreateUser(context *gin.Context) {
	var user User
	context.Bind(&user)
	response, err := saveUser(user)
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save new user"})
		return
	} else {
		context.JSON(http.StatusOK, gin.H{"email": response})
		return
	}
}

func UpdateUser(c *gin.Context) {}

func DeleteUser(c *gin.Context) {}
