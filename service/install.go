package service

import (
	"context"

	"github.com/aaro-n/sonic/model/param"
)

type InstallService interface {
	InstallBlog(ctx context.Context, installParam param.Install) error
}
