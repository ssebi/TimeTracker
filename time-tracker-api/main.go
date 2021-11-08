package main

import (
	"time-tracker/src/controllers"
	"time-tracker/src/shared"

	"github.com/gin-gonic/gin"
	"github.com/kpango/glg"
	swaggerfiles "github.com/swaggo/files"
	swagger "github.com/swaggo/gin-swagger"
	"github.com/swaggo/swag/example/basic/docs"
)

func main() {

	//Db Connect and Close
	shared.Init()
	defer shared.CloseDb()
	// Gin
	// gin.SetMode(gin.ReleaseMode)
	engine := gin.New()
	engine.Use(gin.Logger())

	docs.SwaggerInfo.BasePath = "/api"
	engine.GET("/swagger/*any", swagger.WrapHandler(swaggerfiles.Handler))

	api := engine.Group("/api")
	controllers.Init(engine, api)
	host := "http://localhost:3000"
	glg.Infof("✅ Server running at 👉 %s", host)
	glg.Infof("📄 Swagger 👉 %s/swagger/index.html", host)
	glg.Infof("🩺 Check Health 👉 %s", host)
	engine.Run("localhost:3000")
}
