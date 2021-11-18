package clients

import (
	"time-tracker/src/shared"

	"github.com/gin-gonic/gin"
)

func RegisterClientsController(api *gin.RouterGroup) {
	api.GET("/clients", GetClients)
	api.GET("/clients/:id", GetClient)
	api.POST("/clients", CreateClient)
	api.DELETE("/clients/:id", DeleteClient)
}

// @Tags clients
// @Produce json
// @Success 200
// @Router /clients [get]
func GetClients(context *gin.Context) {
	clients, err := GetAllClients()
	if err != nil {
		shared.ErrorResponse(context, 0, err)
	} else {
		shared.SuccessResponse(context, clients)
	}
}

// @Tags clients
// @Produce application/json
// Description get client by id
// @Success 200
// @Router /clients/:id [get]
// @Param id path string true "Clients ID"
func GetClient(context *gin.Context) {}

// @Tags clients
// @Produce application/json
// @Accept  application/json
// Description create client
// @Param client body clients.Client true "Client"
// @Success 200
// @Router /clients [post]
func CreateClient(context *gin.Context) {
	var client Client
	context.Bind(&client)
	response, err := SaveClient(client)
	if err != nil {
		shared.ErrorResponse(context, 0, err)
	} else {
		shared.SuccessResponse(context, response)
	}
}

// @Tags clients
// @Produce json
// Description delete clients by id
// @Success 200
// @Router /clients/:id [delete]
// @Param id path string true "Client ID"
func DeleteClient(context *gin.Context) {}
