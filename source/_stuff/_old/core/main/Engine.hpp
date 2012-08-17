
#ifndef NEO_GUARD_FDTD_MODULE_HPP
#define NEO_GUARD_FDTD_MODULE_HPP

#include "Module.hpp"

namespace neo {

  class FDTDModule : public Module {

  public:
    
    FDTDModule() : Module("FDTD") {
      addSequence("stepE");
      addSequence("stepH");
    }
    
    static void stepE() {
      
    }
    
    static void stepH() {
      
      
    }

  };

}


#endif // NEO_GUARD_FDTD_MODULE_HPP
