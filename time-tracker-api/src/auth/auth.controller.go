package auth

import (
	"time-tracker/src/shared"
	"time-tracker/src/users"

	"github.com/gin-gonic/gin"
)

func RegisterAuthController(engine *gin.Engine) {
	engine.POST("/login", LoginController)
	engine.POST("/register", Register)
}

// @Tags auth
// @Produce json
// @Success 200
// @Router /login [post]
func LoginController(context *gin.Context) {
	var login LoginDTO
	context.Bind(&login)
	response, err := LoginUser(login)
	if err != nil {
		shared.ErrorResponse(context, 0, err)
	} else {
		shared.SuccessResponse(context, response)
	}
}

// @Tags auth
// @Produce json
// @Success 200
// @Router /register [post]
func Register(context *gin.Context) {
	var user users.User
	context.Bind(&user)
	response, err := users.SaveUser(user)
	if err != nil {
		shared.ErrorResponse(context, 0, err)
	} else {
		shared.SuccessResponse(context, response)
	}
}
