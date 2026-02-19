package service

import (
	"context"

	"github.com/aaro-n/sonic/model/dto"
	"github.com/aaro-n/sonic/model/entity"
	"github.com/aaro-n/sonic/model/param"
)

type LogService interface {
	PageLog(ctx context.Context, page param.Page, sort *param.Sort) ([]*entity.Log, int64, error)
	ConvertToDTO(log *entity.Log) *dto.Log
	Clear(ctx context.Context) error
}
