package api

import (
	"github.com/gin-gonic/gin"

	"github.com/aaro-n/sonic/service"
	"github.com/aaro-n/sonic/util"
)

type PhotoHandler struct {
	PhotoService service.PhotoService
}

func NewPhotoHandler(photoService service.PhotoService) *PhotoHandler {
	return &PhotoHandler{
		PhotoService: photoService,
	}
}

func (p *PhotoHandler) Like(ctx *gin.Context) (interface{}, error) {
	id, err := util.ParamInt32(ctx, "photoID")
	if err != nil {
		return nil, err
	}
	return nil, p.PhotoService.IncreaseLike(ctx, id)
}
