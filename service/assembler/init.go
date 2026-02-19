package assembler

import "github.com/aaro-n/sonic/injection"

func init() {
	injection.Provide(
		NewBasePostAssembler,
		NewPostAssembler,
		NewSheetAssembler,
		NewBaseCommentAssembler,
		NewPostCommentAssembler,
		NewJournalCommentAssembler,
		NewSheetCommentAssembler,
	)
}
