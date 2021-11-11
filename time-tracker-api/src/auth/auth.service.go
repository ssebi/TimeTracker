package auth

import (
	"errors"
	"time"
	"time-tracker/src/users"

	"github.com/dgrijalva/jwt-go"
	"github.com/kpango/glg"
	"golang.org/x/crypto/bcrypt"
)

type LoginDTO struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

var jwtSecret = "i-love-drugs"

type JwtCustomClaims struct {
	Email string `json:"email"`
	jwt.StandardClaims
}

func GenerateToken(email string) string {
	claims := &JwtCustomClaims{
		email,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 72).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString([]byte(jwtSecret))
	if err != nil {
		panic(err)
	}
	return t
}

func ValidateToken(tokenString string) (*jwt.Token, error) {
	return jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Signing method validation
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, glg.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}
		// Return the secret signing key
		return []byte(jwtSecret), nil
	})
}

func LoginUser(login LoginDTO) (*string, error) {
	user, err := users.FindUserByEmail(login.Email)
	if err != nil {
		return nil, err
	}
	if user.ID == "" {
		return nil, errors.New("user not found")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(login.Password))
	if err != nil {
		return nil, errors.New("wrong password")
	}

	token := GenerateToken(user.Email)
	return &token, nil
}
