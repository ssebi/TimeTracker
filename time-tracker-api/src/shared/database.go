package shared

import (
	"github.com/kpango/glg"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var database *gorm.DB
var err error

func Init() {
	//PostgreSQL
	glg.Info("Database connecting...")

	dsn := "postgres://postgres:postgres@localhost:5444/time-tracker?sslmode=disable"

	database, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		glg.Error(err)
	}
}

func Database() *gorm.DB {
	return database
}

func CloseDb() {
	db, err := database.DB()
	if err != nil {
		glg.Error(err)
	}
	db.Close()
}
