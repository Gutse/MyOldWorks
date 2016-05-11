using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using System.IO;
namespace pstats
{
    enum ERRORS {
        ERR_NOERROR = 0,
        ERR_WRONGARGS = 1,
        ERR_NOSUCHFILE = 2,
        ERR_FILEOPENEROR = 3,
        ERR_SHITOPENERROR = 4,
        ERR_EMPTYFILE = 5,
        ERR_NODATA = 6,
        ERR_SHEETCREATEERROR = 7,
        ERR_SAVEERROR = 8
    }    
    class ActionRecord
    {
        public string unique { set; get; }
        public DateTime time { set; get; }
        public string action { set; get; }
    }

    class PercoPerson
    {
        public string tab { set; get; }
        public string fio { set; get; }
        public string unique { set; get; }
        public List<ActionRecord> records { set; get; }

        public PercoPerson()
        {
            records = new List<ActionRecord>();
        }

    }

    class Program
    {
        static protected HSSFWorkbook hssfwb;

        static int Main(string[] args)
        {
            if (args.Count() != 1) {
                return (int)ERRORS.ERR_WRONGARGS;
            }
            if (!System.IO.File.Exists(args[0])) {
                return (int)ERRORS.ERR_NOSUCHFILE;
            }

            /*qqq*/
            List<PercoPerson> Persons = new List<PercoPerson>();
            int ret = LoadFile(args[0], Persons);
            if (ret != (int) ERRORS.ERR_NOERROR)
            {
                return ret;
            }

            ISheet new_sheet, stat_sheet;
            try
            {
                new_sheet = hssfwb.CreateSheet("Детально");
            }
            catch
            {
                try
                {
                    new_sheet = hssfwb.CreateSheet();
                }
                catch (Exception Ex)
                {
                    Console.WriteLine("Не удалось создать лист результатов: " + Ex.Message);
                    return (int)ERRORS.ERR_SHEETCREATEERROR;
                }
            }

            try
            {
                stat_sheet = hssfwb.CreateSheet("Статистика");
            }
            catch
            {
                try
                {
                    stat_sheet = hssfwb.CreateSheet();
                }
                catch (Exception Ex)
                {
                    Console.WriteLine("Не удалось создать лист результатов: " + Ex.Message);
                    return (int)ERRORS.ERR_SHEETCREATEERROR;
                }
            }

            // создаем стили 
            IFont BoldFont = hssfwb.CreateFont();
            IFont NormalFont = hssfwb.CreateFont();
            ICellStyle BoldStyle = hssfwb.CreateCellStyle();
            ICellStyle NormalStyle = hssfwb.CreateCellStyle();

            BoldFont.Boldweight = (short)FontBoldWeight.Bold;
            NormalFont.Boldweight = (short)FontBoldWeight.Normal;

            BoldStyle.WrapText = true;
            BoldStyle.SetFont(BoldFont);
            NormalStyle.SetFont(NormalFont);

            //устанавливаем стиль по умолчанию
            for (int col = 0; col <= 6; col++) {
                new_sheet.SetDefaultColumnStyle(col, NormalStyle);
                stat_sheet.SetDefaultColumnStyle(col, NormalStyle);
            }

            //создаем шапку
            IRow dataRow = new_sheet.CreateRow(0);
            dataRow.CreateCell(0).SetCellValue("Всего людей: ");
            dataRow.CreateCell(1).SetCellValue(Persons.Count.ToString());
            set_row_style(dataRow, BoldStyle);

            dataRow = new_sheet.CreateRow(1);
            dataRow.HeightInPoints = 28;
            dataRow.CreateCell(0).SetCellValue("Табельный");
            dataRow.CreateCell(1).SetCellValue("ФИО");
            dataRow.CreateCell(2).SetCellValue("Событие");
            dataRow.CreateCell(3).SetCellValue("Время");
            dataRow.CreateCell(4).SetCellValue("Длительность в секундах");
            dataRow.CreateCell(5).SetCellValue("в минутах");
            dataRow.CreateCell(6).SetCellValue("в часах");
            set_row_style(dataRow, BoldStyle);

            //создаем шапку (лист статистики)
            dataRow = stat_sheet.CreateRow(0);
            dataRow.CreateCell(0).SetCellValue("Всего людей: ");
            dataRow.CreateCell(1).SetCellValue(Persons.Count.ToString());
            set_row_style(dataRow, BoldStyle);

            dataRow = stat_sheet.CreateRow(1);
            dataRow.HeightInPoints = 28;
            dataRow.CreateCell(0).SetCellValue("Табельный");
            dataRow.CreateCell(1).SetCellValue("ФИО");
            dataRow.CreateCell(2).SetCellValue("Длительность в секундах");
            dataRow.CreateCell(3).SetCellValue("в минутах");
            dataRow.CreateCell(4).SetCellValue("в часах");
            set_row_style(dataRow, BoldStyle);


            double global_seconds = 0;
            TimeSpan t;
            int nrow = 2;
            int srow = 2;



            foreach (PercoPerson pers in Persons)
            {
                //сорртируем записи о проходах, на случай ручного заполнения файла.
                pers.records.Sort((x, y) => x.time.CompareTo(y.time));

                dataRow = new_sheet.CreateRow(nrow);
                dataRow.CreateCell(0).SetCellValue(pers.tab);
                dataRow.CreateCell(1).SetCellValue(pers.fio);

                dataRow = stat_sheet.CreateRow(srow);
                dataRow.CreateCell(0).SetCellValue(pers.tab);
                dataRow.CreateCell(1).SetCellValue(pers.fio);

                double local_seconds = 0;

                for (int i = 0; i < pers.records.Count; i++)
                {
                    ActionRecord rec = pers.records[i];
                    nrow++;
                    dataRow = new_sheet.CreateRow(nrow);
                    //dataRow.ZeroHeight = true;
                    dataRow.CreateCell(2).SetCellValue(rec.action);
                    dataRow.CreateCell(3).SetCellValue(rec.time.ToString());
                    if (rec.action == "Выход")
                    {
                        double duration = 0;
                        if ((i > 0) && (pers.records[i - 1].action == "Вход"))
                        {
                            duration = (rec.time - pers.records[i - 1].time).TotalSeconds;
                            if (duration > 86400) // это на случай если длительность пребывания больше суток.
                            {
                                duration = 0;
                            }
                            local_seconds = local_seconds + duration;
                        }
                        else
                        {

                        }
                        t = TimeSpan.FromSeconds(duration);

                        dataRow.CreateCell(4).SetCellValue(duration);
                        dataRow.CreateCell(5).SetCellValue(t.TotalMinutes);
                        dataRow.CreateCell(6).SetCellValue(t.TotalHours);
                    }

                }

                t = TimeSpan.FromSeconds(local_seconds);

                nrow++;
                dataRow = new_sheet.CreateRow(nrow);
                dataRow.CreateCell(0).SetCellValue("Итого");
                dataRow.CreateCell(4).SetCellValue(t.TotalSeconds);
                dataRow.CreateCell(5).SetCellValue(t.TotalMinutes);
                dataRow.CreateCell(6).SetCellValue(t.TotalHours);
                set_row_style(dataRow, BoldStyle);

                dataRow = stat_sheet.GetRow(srow);
                dataRow.CreateCell(2).SetCellValue(t.TotalSeconds);
                dataRow.CreateCell(3).SetCellValue(t.TotalMinutes);
                dataRow.CreateCell(4).SetCellValue(t.TotalHours);
                srow++;



                global_seconds = global_seconds + local_seconds;
                nrow++;
            }
            t = TimeSpan.FromSeconds(global_seconds);
            // вставляем итоги
            nrow++;
            dataRow = new_sheet.CreateRow(nrow);
            dataRow.CreateCell(0).SetCellValue("Итого по всем");
            dataRow.CreateCell(4).SetCellValue(t.TotalSeconds);
            dataRow.CreateCell(5).SetCellValue(t.TotalMinutes);
            dataRow.CreateCell(6).SetCellValue(t.TotalHours);
            set_row_style(dataRow, BoldStyle);
            srow++;
            dataRow = stat_sheet.CreateRow(srow);
            dataRow.CreateCell(0).SetCellValue("Итого по всем");

            int f = Persons.Count + 2;
            dataRow.CreateCell(2).SetCellValue("");
            dataRow.CreateCell(3).SetCellValue("");
            dataRow.CreateCell(4).SetCellValue("");
            dataRow.GetCell(2).CellFormula = "SUM(C3:C" + f + ")";
            dataRow.GetCell(3).CellFormula = "SUM(D3:D" + f + ")";
            dataRow.GetCell(4).CellFormula = "SUM(E3:E" + f + ")";
            set_row_style(dataRow, BoldStyle);

            //среднее
            nrow++;
            dataRow = new_sheet.CreateRow(nrow);
            dataRow.CreateCell(0).SetCellValue("В среднем");
            dataRow.CreateCell(4).SetCellValue(t.TotalSeconds / Persons.Count);
            dataRow.CreateCell(5).SetCellValue(t.TotalMinutes / Persons.Count);
            dataRow.CreateCell(6).SetCellValue(t.TotalHours / Persons.Count);
            set_row_style(dataRow, BoldStyle);

            srow++;
            f = srow;
            dataRow = stat_sheet.CreateRow(srow);
            dataRow.CreateCell(0).SetCellValue("В среднем");
            dataRow.CreateCell(2).SetCellValue("");
            dataRow.CreateCell(3).SetCellValue("");
            dataRow.CreateCell(4).SetCellValue("");
            dataRow.GetCell(2).CellFormula = "C" + f + "/B1";
            dataRow.GetCell(3).CellFormula = "D" + f + "/B1"; ;
            dataRow.GetCell(4).CellFormula = "E" + f + "/B1"; ;
            set_row_style(dataRow, BoldStyle);

            //устанавливаем размеры колонок
            new_sheet.SetColumnWidth(0, 3232);
            new_sheet.SetColumnWidth(1, 5056);
            new_sheet.SetColumnWidth(2, 2308);
            new_sheet.SetColumnWidth(3, 5216);
            new_sheet.SetColumnWidth(4, 6168);
            new_sheet.SetColumnWidth(5, 2448);

            stat_sheet.SetColumnWidth(0, 3232);
            stat_sheet.SetColumnWidth(1, 5056);
            stat_sheet.SetColumnWidth(2, 6168);
            stat_sheet.SetColumnWidth(3, 2448);
            stat_sheet.SetColumnWidth(4, 2448);
            //сохраняем результат
            using (FileStream file = new FileStream(args[0], FileMode.Open, FileAccess.ReadWrite))
            {
                try
                {
                    hssfwb.Write(file);
                }
                catch (Exception Ex)
                {
                    Console.WriteLine("Не удалось сохранить результат: " + Ex.Message);
                    return (int)ERRORS.ERR_SAVEERROR;
                }
            }
            Console.WriteLine("Готово");
            return (int) ERRORS.ERR_NOERROR;
        }

        private static int LoadFile(string filename, List<PercoPerson> Persons)
        {

            FileStream file;

            using (file = new FileStream(filename, FileMode.Open, FileAccess.Read))
            {
                try
                {
                    hssfwb = new HSSFWorkbook(file);
                }
                catch (Exception e)
                {

                    Console.WriteLine("Не удалось открыть файл: " + e.Message);
                    return (int)ERRORS.ERR_FILEOPENEROR;
                }
            }


            ISheet sheet;
            try
            {
                sheet = hssfwb.GetSheetAt(0);
            }
            catch (Exception e)
            {
                Console.WriteLine("Не удалось открыть лист 0: " + e.Message);
                return (int)ERRORS.ERR_SHITOPENERROR;
            }

            if (sheet.LastRowNum < 2)
            {
                Console.WriteLine("Файл не заполнен");
                return (int)ERRORS.ERR_EMPTYFILE;
            }

            string _tabnum;
            string _fio;
            string _date;
            string _time;
            string _action;
            DateTime _datetime;
            PercoPerson tmp;


            for (int row = 1; row <= sheet.LastRowNum; row++)
            {
                if (sheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    try
                    {
                        _tabnum = sheet.GetRow(row).GetCell(0).StringCellValue.Trim();
                        _fio = sheet.GetRow(row).GetCell(1).StringCellValue.Trim();
                        _date = sheet.GetRow(row).GetCell(2).StringCellValue.Trim();
                        _time = sheet.GetRow(row).GetCell(3).StringCellValue.Trim();
                        _action = sheet.GetRow(row).GetCell(5).StringCellValue.Trim();
                    }
                    catch
                    {
                        continue;
                    }

                    if ((_action != "Вход") && (_action != "Выход"))
                    {
                        continue;
                    }

                    if (Persons.Exists(x => x.unique == _tabnum + _fio))
                    {
                        tmp = Persons.Find(x => x.unique == _tabnum + _fio);
                    }
                    else
                    {
                        tmp = new PercoPerson { tab = _tabnum, fio = _fio, unique = _tabnum + _fio };
                        Persons.Add(tmp);
                    }

                    try
                    {
                        _datetime = DateTime.Parse(_date + ' ' + _time);
                    }
                    catch
                    {
                        continue;
                    }

                    tmp.records.Add(new ActionRecord { unique = _tabnum + _fio, action = _action, time = _datetime });
                }
            }
            if (Persons.Count == 0)
            {
                Console.WriteLine("Не удалось загрузить файл так как не найдено ни одного события о проходах");
                return (int)ERRORS.ERR_NODATA;
            }
            return (int)ERRORS.ERR_NOERROR;
        }

        private static void set_row_style(IRow row, ICellStyle style)
        {
            foreach (ICell row_cell in row.Cells)
            {
                row_cell.CellStyle = style;
            }

        }



    }
}
