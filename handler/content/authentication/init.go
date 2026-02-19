package authentication

import "github.com/aaro-n/sonic/injection"

func init() {
	injection.Provide(
		NewCategoryAuthentication,
		NewPostAuthentication,
	)
}
