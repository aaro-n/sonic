package content

import "github.com/aaro-n/sonic/injection"

func init() {
	injection.Provide(
		NewIndexHandler,
		NewFeedHandler,
		NewArchiveHandler,
		NewViewHandler,
		NewCategoryHandler,
		NewSheetHandler,
		NewTagHandler,
		NewLinkHandler,
		NewPhotoHandler,
		NewJournalHandler,
		NewSearchHandler,
	)
}
