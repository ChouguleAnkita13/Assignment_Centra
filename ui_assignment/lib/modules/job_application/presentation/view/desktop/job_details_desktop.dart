import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_assignment/modules/job_application/data/models/job_details_response_model.dart';
import 'package:ui_assignment/modules/job_application/presentation/bloc/job_details_bloc.dart';
import 'package:ui_assignment/modules/job_application/presentation/bloc/job_details_event.dart';
import 'package:ui_assignment/modules/job_application/presentation/bloc/job_details_state.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_container.dart';

class JobDetailsDesktop extends StatelessWidget {
  const JobDetailsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    JobDetailsBloc jobDetailsBloc = JobDetailsBloc();
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: BlocProvider<JobDetailsBloc>(
          create: (context) =>
              jobDetailsBloc..add(JobDetailsInitialEvent(selectedIndex: 0)),
          child: BlocBuilder<JobDetailsBloc, JobDetailsState>(
              builder: (context, state) {
            if (state is JobDetailsSuccessState) {
              return Row(
                children: [
                  _mainImageContainer(context),

                  ///HEADER TABBARS
                  _headerTabbars(context, jobDetailsBloc, state)
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ));
  }
}

///HEADER TABBARS
Widget _headerTabbars(BuildContext context, JobDetailsBloc jobDetailsBloc,
    JobDetailsSuccessState state) {
  return DefaultTabController(
    length: 5,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///TABBARS
          TabBar(
              onTap: (value) {
                jobDetailsBloc
                    .add(JobDetailsInitialEvent(selectedIndex: value));
              },
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Color.fromRGBO(1, 60, 110, 1),
              tabAlignment: TabAlignment.center,
              unselectedLabelStyle: GoogleFonts.poppins(
                  color: Color.fromRGBO(64, 64, 64, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              labelStyle: GoogleFonts.poppins(
                  color: Color.fromRGBO(1, 60, 110, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              tabs: [
                Text("Job Details"),
                Text("Basic Information"),
                Text("Educational Details"),
                Text("Technical Skills"),
                Text("Upload Resume"),
              ]),

          ///TABVIEWS
          SizedBox(
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height / 1.2,
              child: TabBarView(children: [
                _jobDetails(context, jobDetailsBloc, state),
                Text("Basic Information"),
                Text("Educational Details"),
                Text("Technical Skills"),
                Text("Upload Resume"),
              ])),
        ],
      ),
    ),
  );
}

///DROPDOWN
Widget _dropdown(BuildContext context, JobDetailsBloc jobDetailsBloc,
    JobDetailsSuccessState state) {
  return Container(
    height: 49,
    width: MediaQuery.of(context).size.width / 9,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 1),
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            blurRadius: 14),
      ],
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: state.selectedDropdownValue,
        dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
        icon: const Icon(Icons.keyboard_arrow_down,
            color: Color.fromRGBO(0, 0, 0, 1)),
        isExpanded: true,
        onChanged: (String? newValue) {
          jobDetailsBloc
              .add(OnDropdownSelectionEvent(selectedDropdownValue: newValue!));
        },
        items: [
          "UI Designer",
          "UX Designer",
          "Interaction Designer",
          "Graphic Designer"
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

//JOB DETAILS WIDGET
Widget _jobDetails(BuildContext context, JobDetailsBloc jobDetailsBloc,
    JobDetailsSuccessState state) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2.2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///DROPDOWN
        _dropdown(context, jobDetailsBloc, state),

        ///DIVIDER
        Container(
          color: Color.fromRGBO(166, 166, 166, 0.2),
          width: 2,
        ),

        SizedBox(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _roleContainer(state.jobDetails.role),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomContainer(
                      img: "assets/images/location.png",
                      title: state.jobDetails.location),
                  CustomContainer(
                      img: "assets/images/work.png",
                      title: state.jobDetails.work),
                  CustomContainer(
                      img: "assets/images/time.png",
                      title: state.jobDetails.time),
                ],
              ),
              _allMenuContainer(context, state.jobDetails.menu),
              _applyButtonContainer()
            ],
          ),
        ),
      ],
    ),
  );
}

///ALL MENU CONTAINER
Widget _allMenuContainer(BuildContext context, List<Menu> menu) {
  return DefaultTabController(
    length: menu.length,
    child: Column(
      children: [
        Container(
          height: 45,
          margin: EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.circular(3)),
          child: TabBar(
              indicatorWeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              tabAlignment: TabAlignment.center,
              unselectedLabelStyle: GoogleFonts.poppins(
                  color: Color.fromRGBO(64, 64, 64, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              labelStyle: GoogleFonts.poppins(
                  color: Color.fromRGBO(1, 60, 110, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              indicator: BoxDecoration(
                  color: Color.fromRGBO(203, 229, 251, 1),
                  border: Border.all(color: Color.fromRGBO(1, 60, 110, 1)),
                  borderRadius: BorderRadius.circular(5)),
              tabs: List.generate(
                menu.length,
                (index) => Text(menu[index].name),
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4.5,
          child: TabBarView(
              children: List.generate(menu.length,
                  (index) => _viewMenuList(context, menu[index].list))),
        ),
      ],
    ),
  );
}

///APPLY NOW BUTTON
Widget _applyButtonContainer() {
  return Container(
    height: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Color.fromRGBO(1, 60, 110, 1),
        borderRadius: BorderRadius.circular(100)),
    child: Text(
      "APPLY NOW",
      style: GoogleFonts.poppins(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontSize: 16,
          fontWeight: FontWeight.w600),
    ),
  );
}

///MAIN IMAGE AT LEFT SIDE
Widget _mainImageContainer(BuildContext context) {
  return Container(
    alignment: Alignment.bottomCenter,
    width: MediaQuery.of(context).size.width / 2.2,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage(
            "assets/images/main_page.png",
          ),
          fit: BoxFit.cover),
    ),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        "Dream · Connect · Achieve ",
        style: GoogleFonts.poppins(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 38,
            fontWeight: FontWeight.w700),
      ),
    ),
  );
}

///

///ROLE CONTAINER
Widget _roleContainer(String role) {
  return Column(
    children: [
      Container(
        height: 155,
        width: 155,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: Color.fromRGBO(203, 229, 251, 1),
            border: Border.all(color: Color.fromRGBO(1, 60, 110, 1)),
            borderRadius: BorderRadius.circular(3)),
        child: Image.asset("assets/images/vector.png"),
      ),
      Text(
        role,
        style: GoogleFonts.poppins(
            color: Color.fromRGBO(64, 64, 64, 1),
            fontSize: 23,
            fontWeight: FontWeight.w500),
      )
    ],
  );
}

///Content List
Widget _viewMenuList(BuildContext context, List contentList) {
  return ListView.builder(
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 50),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8, color: Color.fromRGBO(64, 64, 64, 1)),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  "${contentList[index]}",
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(64, 64, 64, 1),
                    fontSize: 16,
                    wordSpacing: 5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
