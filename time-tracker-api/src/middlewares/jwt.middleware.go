package middlewares

import (
	"errors"
	"log"
	"net/http"
	auth "time-tracker/src/auth"
	shared "time-tracker/src/shared"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

func AuthorizeJWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		const BEARER_SCHEMA = "Bearer "
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			shared.ErrorResponse(c, http.StatusUnauthorized, errors.New("missing authorization header"))
			return
		}
		tokenString := authHeader[len(BEARER_SCHEMA):]
		token, err := auth.ValidateToken(tokenString)
		if err != nil {
			shared.ErrorResponse(c, http.StatusUnauthorized, errors.New("invalid bearer token"))
			return
		}
		if token.Valid {
			claims := token.Claims.(jwt.MapClaims)
			log.Println("Claims[Name]: ", claims["name"])
		} else {
			log.Println(err)
			c.AbortWithStatus(http.StatusUnauthorized)
		}
	}
}
