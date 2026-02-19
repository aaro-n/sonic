package filestorageimpl

import "github.com/aaro-n/sonic/injection"

func init() {
	injection.Provide(
		NewMinIO,
		NewLocalFileStorage,
		NewAliyun,
	)
}
