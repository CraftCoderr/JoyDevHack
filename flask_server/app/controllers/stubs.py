def SMS_ru_stub():
    return {
            "status": "OK",
            "status_code": 100,
            "sms": {
                "79781027688": {
                    "status": "OK",
                    "status_code": 100,
                    "sms_id": "000000-10000000"
                },
                "74993221627": {
                    "status": "ERROR",
                    "status_code": 207,
                    "status_text": "На этот номер (или один из номеров) нельзя отправлять сообщения, либо указано более 100 номеров в списке получателей"
                }
            },
            "balance": 4122.56
        }