package users

import (
	shared "time-tracker/src/shared"

	"github.com/gin-gonic/gin"
)

func RegisterUsersController(api *gin.RouterGroup) {
	api.GET("/users", GetUsers)
	api.GET("/users/:id", GetUser)
	api.POST("/users", CreateUser)
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
// @Produce application/json
// Description get user by id
// @Success 200
// @Router /users/:id [get]
// @Param id path string true "User ID"
func GetUser(c *gin.Context) {
	id := c.Param("id")
	user, err := GetUserById(id)
	if err != nil {
		shared.ErrorResponse(c, 0, err)
	} else {
		shared.SuccessResponse(c, user)
	}
}

// @Tags users
// @Produce application/json
// @Accept  application/json
// Description create user
// @Param user body users.User true "User"
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

// @Tags users
// @Produce json
// Description delete user by id
// @Success 200
// @Router /users/:id [delete]
// @Param id path string true "User ID"
func DeleteUser(c *gin.Context) {
	id := c.Param("id")
	err := DeleteUserById(id)
	if err != nil {
		shared.ErrorResponse(c, 0, err)
	} else {
		shared.SuccessResponse(c, nil)
	}
}
