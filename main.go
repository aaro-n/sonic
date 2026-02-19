package main

import (
	"context"

	"go.uber.org/fx"

	"github.com/aaro-n/sonic/cache"
	"github.com/aaro-n/sonic/config"
	"github.com/aaro-n/sonic/dal"
	"github.com/aaro-n/sonic/event"
	"github.com/aaro-n/sonic/event/listener"
	"github.com/aaro-n/sonic/handler"
	"github.com/aaro-n/sonic/handler/middleware"
	"github.com/aaro-n/sonic/injection"
	"github.com/aaro-n/sonic/log"
	"github.com/aaro-n/sonic/template"
	"github.com/aaro-n/sonic/template/extension"
)

var eventBus event.Bus

func main() {
	app := InitApp()

	if err := app.Start(context.Background()); err != nil {
		panic(err)
	}
	eventBus.Publish(context.Background(), &event.StartEvent{})
	<-app.Done()
}

func InitApp() *fx.App {
	options := injection.GetOptions()
	options = append(options,
		fx.NopLogger,
		fx.Provide(
			log.NewLogger,
			log.NewGormLogger,
			event.NewSyncEventBus,
			dal.NewGormDB,
			cache.NewCache,
			config.NewConfig,
			handler.NewServer,
			template.NewTemplate,
			middleware.NewAuthMiddleware,
			middleware.NewGinLoggerMiddleware,
			middleware.NewRecoveryMiddleware,
			middleware.NewInstallRedirectMiddleware,
		),
		fx.Populate(&dal.DB),
		fx.Populate(&eventBus),
		fx.Invoke(
			listener.NewStartListener,
			listener.NewTemplateConfigListener,
			listener.NewLogEventListener,
			listener.NewPostUpdateListener,
			listener.NewCommentListener,
			extension.RegisterCategoryFunc,
			extension.RegisterCommentFunc,
			extension.RegisterTagFunc,
			extension.RegisterMenuFunc,
			extension.RegisterPhotoFunc,
			extension.RegisterLinkFunc,
			extension.RegisterToolFunc,
			extension.RegisterPaginationFunc,
			extension.RegisterPostFunc,
			extension.RegisterStatisticFunc,
			func(s *handler.Server) {
				s.RegisterRouters()
			},
		),
	)
	app := fx.New(
		options...,
	)
	return app
}
