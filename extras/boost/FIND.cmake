
#### find package

# interface cmake's FindBoost.cmake module

find_package(Boost ${FIND_VERSION}) 

set(BOOST_FOUND Boost_FOUND)
set(BOOST_VERSION ${Boost_LIB_VERSION})
set(BOOST_INCLUDE_DIR ${Boost_INCLUDE_DIR} )
set(BOOST_LIBRARY_DIR ${Boost_LIBRARY_DIR} )
set(BOOST_LIBRARIES ${Boost_LIBRARIES} )

