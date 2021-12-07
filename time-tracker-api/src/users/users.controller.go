package users

import (
	"time-tracker/src/clients"
	shared "time-tracker/src/shared"

	"github.com/gin-gonic/gin"
)

func RegisterUsersController(api *gin.RouterGroup) {
	api.GET("/users", GetUsersController)
	api.POST("/users/:id/projects", AddUserProjectController)
	api.POST("/users/:id/worklog", AddUserWorklogController)
	api.GET("/users/:id/worklog", GetWorklogController)
	api.GET("/users/:id", GetUserController)
	api.POST("/users", CreateUserController)
	api.DELETE("/users/:id", DeleteUserController)
}

// @Tags users
// @Produce json
// @Success 200
// @Router /users/:id/projects [POST]
func AddUserProjectController(c *gin.Context) {
	var project clients.Project
	c.Bind(&project)
	id := c.Param("id")
	err := AddUserProject(id, project)
	if err != nil {
		shared.ErrorResponse(c, 0, err)
	} else {
		shared.SuccessResponse(c, nil)
	}
}

// @Tags users
// @Produce json
// @Success 200
// @Router /users/:id/worklog [POST]
// @Param worklog body users.Worklog true "worklog"
func AddUserWorklogController(c *gin.Context) {
	var worklog Worklog
	c.Bind(&worklog)
	id := c.Param("id")
	err := AddUserWorklog(id, worklog)
	if err != nil {
		shared.ErrorResponse(c, 0, err)
	} else {
		shared.SuccessResponse(c, nil)
	}
}

// @Tags users
// @Produce json
// @Success 200
// @Router /users/:id/worklog [GET]
func GetWorklogController(c *gin.Context) {
	id := c.Param("id")
	worklog, err := GetUserWorklog(id)
	if err != nil {
		shared.ErrorResponse(c, 0, err)
	} else {
		shared.SuccessResponse(c, worklog)
	}
}

// @Tags users
// @Produce json
// @Success 200
// @Router /users [get]
func GetUsersController(context *gin.Context) {
	users, err := GetUsers()
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
func GetUserController(c *gin.Context) {
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
func CreateUserController(context *gin.Context) {
	var user User
	context.Bind(&user)
	response, err := CreateUser(user)
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
func DeleteUserController(c *gin.Context) {
	id := c.Param("id")
	err := DeleteUserById(id)
	if err != nil {
		shared.ErrorResponse(c, 0, err)
	} else {
		shared.SuccessResponse(c, nil)
	}
}
