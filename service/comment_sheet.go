package service

import (
	"context"

	"github.com/aaro-n/sonic/consts"
)

type SheetCommentService interface {
	BaseCommentService
	CountByStatus(ctx context.Context, status consts.CommentStatus) (int64, error)
}
