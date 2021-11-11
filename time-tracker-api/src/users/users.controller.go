package users

import (
	shared "time-tracker/src/shared"

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
func GetUsers(context *gin.Context) {
	users, err := GetAllUsers()
	if err != nil {
		shared.ErrorResponse(context, 0, err)
	} else {
		shared.SuccessResponse(context, users)
	}
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
	response, err := SaveUser(user)
	if err != nil {
		shared.ErrorResponse(context, 0, err)
	} else {
		shared.SuccessResponse(context, response)
	}
}

func UpdateUser(c *gin.Context) {}

func DeleteUser(c *gin.Context) {}
