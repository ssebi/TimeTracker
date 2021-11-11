package main

import (
	"time-tracker/docs"
	"time-tracker/src/controllers"

	"github.com/gin-gonic/gin"
	"github.com/kpango/glg"
	swaggerfiles "github.com/swaggo/files"
	swagger "github.com/swaggo/gin-swagger"
)

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
