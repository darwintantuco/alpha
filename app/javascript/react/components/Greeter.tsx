import * as React from 'react'

interface GreeterProps {
  name: string
}

const Greeter = (props: GreeterProps) => {
  return (
    <div data-testid='greeter'>
      {props.message}! - from Greeter react component
    </div>
  )
}

export default Greeter
