package auth

type login struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}
