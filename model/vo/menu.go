package vo

import "github.com/aaro-n/sonic/model/dto"

type Menu struct {
	dto.Menu
	Children []*Menu `json:"children"`
}
