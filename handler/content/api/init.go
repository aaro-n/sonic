package api

import "github.com/aaro-n/sonic/injection"

func init() {
	injection.Provide(
		NewArchiveHandler,
		NewCategoryHandler,
		NewJournalHandler,
		NewLinkHandler,
		NewPostHandler,
		NewSheetHandler,
		NewOptionHandler,
		NewPhotoHandler,
		NewCommentHandler,
	)
}
