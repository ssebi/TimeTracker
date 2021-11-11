package auth

import (
	"testing"

	"github.com/kpango/glg"
)

func TestJWTGenerator(t *testing.T) {
	token := GenerateToken("lupu60@gmail.com")

	if token == "" {
		t.Errorf("Expected to get value")
	}
}

func TestTokenShouldBeInValid(t *testing.T) {
	token, err := ValidateToken("dsadsadsa")
	if err == nil && token == nil {
		t.Errorf("Expected token to be invalid")
	}
}
func TestTokenShouldBeValid(t *testing.T) {
	token := GenerateToken("lupu60@gmail.com")
	t.Log(token)
	glg.Error(token)
	result, err := ValidateToken(token)
	if err == nil && result == nil {
		t.Errorf("Expected token to be invalid")
	}
}
