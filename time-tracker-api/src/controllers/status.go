package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func RegisterUtilityController(engine *gin.Engine) {
	engine.GET("/", func(context *gin.Context) {
		context.JSON(http.StatusOK, gin.H{
			"code":    http.StatusOK,
			"message": "OK",
		})
	})
}
