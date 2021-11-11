package controllers

import (
	"time-tracker/src/auth"
	"time-tracker/src/middlewares"
	"time-tracker/src/users"

	"github.com/gin-gonic/gin"
)

func Init(engine *gin.Engine) {
	engine.Use(middlewares.CORSMiddleware())
	api := engine.Group("/api", middlewares.AuthorizeJWT())
	RegisterUtilityController(engine)
	users.RegisterUsersController(api)
	auth.RegisterAuthController(engine)
}
