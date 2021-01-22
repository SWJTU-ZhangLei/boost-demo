#include <boost/asio/yield.hpp>
#include <boost/asio/coroutine.hpp>
#include <iostream>
 
using namespace std;
  
boost::asio::coroutine c;
  
void foo(int i)
{
  cout << "no reenter " << i << endl;
  reenter(c)
  {
    yield cout << "foo1 " << i << endl;
    fork foo(100);
    yield cout << "foo2 " << i+1 << endl;
  }
}
int main()
{
  foo(1);
  foo(2);
  foo(3);
  return 0;
}