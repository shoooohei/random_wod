#!/bin/sh

##############################################################
# コンテナ起動スクリプト
#
#   webサーバとdbサーバのコンテナを起動します。
#
#   $ sh script/start_record_wod_container.sh
#
##############################################################

COMMAND_RESULT=`docker-compose ps -q`

if [ '' == "$COMMAND_RESULT" ] ; then

    # バックグラウンドで起動
    docker-compose up -d --build

    # 開発環境マイグレーション
    docker-compose exec web rails db:migrate

    # 開発環境初期データ投入
    docker-compose exec web rails db:seed

else

    # バックグラウンドで起動のみ
    docker-compose up -d --build

fi

