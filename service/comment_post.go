package service

import (
	"context"

	"github.com/aaro-n/sonic/consts"
	"github.com/aaro-n/sonic/model/entity"
	"github.com/aaro-n/sonic/model/param"
)

type PostCommentService interface {
	BaseCommentService
	CreateBy(ctx context.Context, commentParam *param.Comment) (*entity.Comment, error)
	CountByStatus(ctx context.Context, status consts.CommentStatus) (int64, error)
	UpdateBy(ctx context.Context, commentID int32, commentParam *param.Comment) (*entity.Comment, error)
}
