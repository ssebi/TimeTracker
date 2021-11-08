package controllers

import (
	"time-tracker/src/middlewares"
	"time-tracker/src/users"

	"github.com/gin-gonic/gin"
)

func Init(engine *gin.Engine, api *gin.RouterGroup) {
	engine.Use(middlewares.CORSMiddleware())
	RegisterUtilityController(engine)
	users.RegisterUsersController(api)
}
