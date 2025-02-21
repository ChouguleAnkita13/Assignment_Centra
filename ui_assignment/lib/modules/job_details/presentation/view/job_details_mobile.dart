import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_assignment/modules/job_details/data/models/job_details_response_model.dart';
import 'package:ui_assignment/modules/job_details/presentation/bloc/job_details_bloc.dart';
import 'package:ui_assignment/modules/job_details/presentation/bloc/job_details_event.dart';
import 'package:ui_assignment/modules/job_details/presentation/bloc/job_details_state.dart';
import 'package:ui_assignment/modules/job_details/presentation/widgets/custom_container.dart';

class JobDetailsMobile extends StatelessWidget {
  const JobDetailsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        surfaceTintColor: Color.fromRGBO(255, 255, 255, 1),
        centerTitle: true,
        title: Text(
          "Job Details",
          style: GoogleFonts.poppins(
              color: Color.fromRGBO(64, 64, 64, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider<JobDetailsBloc>(
        create: (
          context,
        ) {
          return JobDetailsBloc()
            ..add(JobDetailsInitialEvent(selectedIndex: 0));
        },
        child: BlocBuilder<JobDetailsBloc, JobDetailsState>(
            builder: (context, state) {
          if (state is JobDetailsSuccessState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _salaryContainer(state.jobDetails.salary),
                      _applyButtonContainer(context),
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}

///ALL MENU CONTAINER
Widget _allMenuContainer(BuildContext context, List<Menu> menu) {
  return DefaultTabController(
    length: menu.length,
    child: Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
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

///Content List
Widget _viewMenuList(BuildContext context, List contentList) {
  return ListView.builder(
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8, color: Color.fromRGBO(64, 64, 64, 1)),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  contentList[index],
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(64, 64, 64, 1),
                    fontSize: 17,
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

///SALARY CONTAINER
Widget _salaryContainer(double salary) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.add_card,
            size: 20,
            color: Color.fromRGBO(23, 190, 199, 1),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Salary",
            style: GoogleFonts.poppins(
                color: Color.fromRGBO(160, 160, 160, 1),
                fontSize: 15,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        "$salary Lakh CTC*",
        style: GoogleFonts.poppins(
            color: Color.fromRGBO(64, 64, 64, 1),
            fontSize: 16,
            fontWeight: FontWeight.w600),
      )
    ],
  );
}

///APPLY NOW BUTTON
Widget _applyButtonContainer(BuildContext context) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width / 2,
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
