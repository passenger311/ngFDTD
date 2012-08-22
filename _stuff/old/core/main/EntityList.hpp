
#ifndef NEO_GUARD_ENTITY_LIST_HPP
#define NEO_GUARD_ENTITY_LIST_HPP

#include "Entity.hpp"

#include <map>
#include <string>
#include <vector>
#include <iostream>

namespace neo {

 
  // ordered list

  template<class _ENTITY> class EntityList {
    
  private:
    
    typedef unsigned int index_t;
    typedef std::vector<_ENTITY> list_t;
    typedef std::map<std::string, index_t> map_t;
    typedef map_t::const_iterator map_iter_t;

    map_t m_map;
    list_t m_list;

  public:
  
    EntityList() { }

    // add entity to list

    bool add(const _ENTITY& entity) {
      const std::string name = entity.getName();
      if ( find(name) != -1 ) {
	m_list.push_back(entity); 
	m_map[name] = count();
	return true;
      }
      return false;
    }

    int find(const std::string& name) const { // find item index (-1=not-found)
      map_iter_t p = m_map.find(name); 
      if ( p != m_map.end() ) {
	return (int) p->second;
      }
      return -1;
    }

    const _ENTITY* get(const std::string& name) const { // get entity by name
      int index = find(name);
      if ( index != -1 ) {
	return &m_list[(index_t)index];
      }
      return NULL;
    }

    const _ENTITY* at(index_t index) const { // get entity by position
      if ( index > 0 && index < count() ) {
	return &m_list[index];
      }
      return NULL;
    }

    bool del(const std::string& name) { // delete item
      int index = find(name);
      if ( index != -1 ) {
	m_map.erase(name);
	m_list.erase(m_list.begin()+index);
	return true;
      }
      return false;
    }
    
    unsigned int count() const {
      return m_list.size();
    }
  
  };


  

} // namespace neo

#endif // NEO_GUARD_ENTITY_LIST_HPP
