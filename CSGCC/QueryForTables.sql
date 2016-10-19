USE [NerderyDB]
GO
/****** Object:  Table [dbo].[matches]    Script Date: 10/18/2016 9:33:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[matches](
	[match_id] [int] NOT NULL,
	[host_team] [int] NOT NULL,
	[guest_team] [int] NOT NULL,
	[host_goals] [int] NOT NULL,
	[guest_goals] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[teams]    Script Date: 10/18/2016 9:33:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[teams](
	[team_id] [int] NOT NULL,
	[team_name] [varchar](30) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
INSERT [dbo].[matches] ([match_id], [host_team], [guest_team], [host_goals], [guest_goals]) VALUES (1, 30, 20, 1, 0)
GO
INSERT [dbo].[matches] ([match_id], [host_team], [guest_team], [host_goals], [guest_goals]) VALUES (2, 10, 20, 1, 2)
GO
INSERT [dbo].[matches] ([match_id], [host_team], [guest_team], [host_goals], [guest_goals]) VALUES (3, 20, 50, 2, 2)
GO
INSERT [dbo].[matches] ([match_id], [host_team], [guest_team], [host_goals], [guest_goals]) VALUES (4, 10, 30, 1, 0)
GO
INSERT [dbo].[matches] ([match_id], [host_team], [guest_team], [host_goals], [guest_goals]) VALUES (5, 30, 50, 0, 1)
GO
INSERT [dbo].[teams] ([team_id], [team_name]) VALUES (10, N'Give')
GO
INSERT [dbo].[teams] ([team_id], [team_name]) VALUES (20, N'Never')
GO
INSERT [dbo].[teams] ([team_id], [team_name]) VALUES (30, N'You')
GO
INSERT [dbo].[teams] ([team_id], [team_name]) VALUES (40, N'Up')
GO
INSERT [dbo].[teams] ([team_id], [team_name]) VALUES (50, N'Gonna')
GO
/****** Object:  Index [UQ__matches__9D7FCBA24BD7AFEE]    Script Date: 10/18/2016 9:33:06 PM ******/
ALTER TABLE [dbo].[matches] ADD UNIQUE NONCLUSTERED 
(
	[match_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__teams__F82DEDBD038D5897]    Script Date: 10/18/2016 9:33:06 PM ******/
ALTER TABLE [dbo].[teams] ADD UNIQUE NONCLUSTERED 
(
	[team_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


	SELECT x.team_id,
			x.team_name,
			SUM(case when x.team_id = x.host and x.hostwins = 1 then 3
						when x.draws = 1 then 1
						when x.team_id = x.guest and x.guestloss = 1 then -3
			 else 0 end) as num_points 
	FROM (
  SELECT b.team_id as team_id, 
  b.team_name as team_name, 
  host_team as host, 
  guest_team as guest,
  case when [host_goals] > [guest_goals] then 1 else 0 end as [hostwins],
  case when [host_goals] = [guest_goals] then 1 else 0 end as [draws],
  case when [host_goals] < [guest_goals] then 1 else 0 end as [guestloss]
  FROM [matches] a
  right outer join [teams] b
  on b.team_id = a.host_team or b.team_id = a.guest_team
  ) as x
  group by x.team_id, x.team_name
  order by SUM(case when x.team_id = x.host and x.hostwins = 1 then 3
						when x.draws = 1 then 1
						when x.team_id = x.guest and x.guestloss = 1 then -3
			 else 0 end) desc

	
--host	guest	hostwins	draws	guestloss
--30	20		1			0		0
--10	20		0			0		1
--20	50		0			1		0
--10	30		1			0		0
--30	50		0			0		1