package theme

import (
	"context"

	"github.com/aaro-n/sonic/model/dto"
)

type ThemeFetcher interface {
	FetchTheme(ctx context.Context, file interface{}) (*dto.ThemeProperty, error)
}
