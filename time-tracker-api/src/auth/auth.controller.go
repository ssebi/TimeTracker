package auth

import "github.com/gin-gonic/gin"

func RegisterAuthController(api *gin.RouterGroup) {
  api.GET("/login", Login)
}

func Login(api *gin.Context) {

}
