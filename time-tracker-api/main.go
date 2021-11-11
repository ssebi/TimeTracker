package main

import (
	"time-tracker/docs"
	"time-tracker/src/controllers"

	"github.com/gin-gonic/gin"
	"github.com/kpango/glg"
	swaggerfiles "github.com/swaggo/files"
	swagger "github.com/swaggo/gin-swagger"
)

// @title Time Tracker Api
// @version 1.0
// @description Time Tracker Api
// @contact.name Bogdan Lupu
// @contact.email lupu60@gmail.com
// @host localhost:3000
// @BasePath /api/
// @securityDefinitions.apikey Bearer
// @in header
// @name Authorization
// @Accept  json
// @Produce  json

func main() {

	// Gin
	// gin.SetMode(gin.ReleaseMode)
	engine := gin.New()
	engine.Use(gin.Recovery(), gin.Logger())

	docs.SwaggerInfo.BasePath = "/api"
	engine.GET("/swagger/*any", swagger.WrapHandler(swaggerfiles.Handler))

	controllers.Init(engine)
	host := "http://localhost:3000"
	glg.Infof("✅ Server running at 👉 %s", host)
	glg.Infof("📄 Swagger 👉 %s/swagger/index.html", host)
	glg.Infof("🩺 Check Health 👉 %s", host)
	engine.Run("localhost:3000")
}
