--cleansing date Dimension table--
SELECT [DateKey]
      ,[FullDateAlternateKey] as Date
      --[DayNumberOfWeek]
      ,[EnglishDayNameOfWeek]  as day
      ,--[SpanishDayNameOfWeek]
     -- ,[FrenchDayNameOfWeek]
     -- [DayNumberOfMonth]
     -- ,[DayNumberOfYear]
      --,[WeekNumberOfYear]
      [EnglishMonthName]  as month
      --,[SpanishMonthName]
      --,[FrenchMonthName]
      ,[MonthNumberOfYear] as monthNbr
      ,[CalendarQuarter]
      ,[CalendarYear] as year
     -- ,[CalendarSemester]
     -- ,[FiscalQuarter]
    --  ,[FiscalYear]
    --  ,[FiscalSemester]
  FROM [AdventureWorksDW2022].[dbo].[DimDate]
  where CalendarYear >=2020