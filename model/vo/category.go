package vo

import "github.com/aaro-n/sonic/model/dto"

type CategoryVO struct {
	dto.CategoryDTO
	Children []*CategoryVO `json:"children"`
}
