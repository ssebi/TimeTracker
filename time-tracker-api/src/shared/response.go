package shared

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Success bool        `json:"success"`
	Error   interface{} `json:"error,omitempty"`
	Data    interface{} `json:"data,omitempty"`
}

func NewResponse(success bool) *Response {
	return &Response{Success: success}
}

func SuccessResponse(context *gin.Context, data interface{}) {
	success := NewResponse(true)
	success.Data = data
	context.JSON(http.StatusOK, success)
}

func ErrorResponse(context *gin.Context, status int, err error) {
	if status == 0 {
		status = http.StatusInternalServerError
	}
	response := NewResponse(false)
	response.Error = err.Error()
	context.AbortWithStatusJSON(status, response)
}
