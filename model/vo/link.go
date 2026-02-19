package vo

import "github.com/aaro-n/sonic/model/dto"

type LinkTeamVO struct {
	Team  string
	Links []*dto.Link
}
