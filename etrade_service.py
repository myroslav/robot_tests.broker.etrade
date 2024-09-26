# -*- coding: utf-8 -*-
import dateutil.parser
from datetime import datetime


def convert_etrade_string_to_proz_string(string):
    return {
        u"Украина": u"Україна",
        u"Киевская область": u"м. Київ",
        u"килограммы": u"кілограм",
        u"кг.": u"кілограм",
        u"грн.": u"UAH",
        u"З ПДВ": True,
        u"Картонки": u"Картонні коробки",
        u"Картонні": u"Картонні коробки",
        u"ПЕРІОД УТОЧНЕНЬ": u"active.enquiries",
        u"ПРИЙОМ ПРОПОЗИЦІЙ": u"active.tendering",
        u"АУКЦІОН": u"active.auction",
    }.get(string, string)

def convert_etrade_month_to_english(date):
    return_val = date.replace(u"Січ", "Jan")
    return_val = return_val.replace(u"Лют", "Feb")
    return_val = return_val.replace(u"Бер", "Mar")
    return_val = return_val.replace(u"Кві", "Apr")
    return_val = return_val.replace(u"Тра", "May")
    return_val = return_val.replace(u"Чер", "Jun")
    return_val = return_val.replace(u"Лип", "Jul")
    return_val = return_val.replace(u"Сер", "Aug")
    return_val = return_val.replace(u"Вер", "Sep")
    return_val = return_val.replace(u"Жов", "Oct")
    return_val = return_val.replace(u"Лис", "Nov")
    return_val = return_val.replace(u"Гру", "Dec")
    return return_val

def convert_etrade_delivery_date(date):
    return_val = date
    if "-" in return_val:
        return_val = return_val.split("- ")[1]
    return datetime.strptime(convert_etrade_month_to_english(return_val), "%d %b, %Y").isoformat()

def convert_date_to_etrade_tender_date(date):
    iso = datetime.strptime(convert_etrade_month_to_english(date), "%d %b, %Y %H:%M").isoformat()
    return iso