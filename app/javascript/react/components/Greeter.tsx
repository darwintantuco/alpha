import * as React from 'react'

interface GreeterProps { name: string }

const Greeter = (props: GreeterProps) => {
  return (
    <div data-testid='greeter'>Hey {props.name}! from Greeter react component</div>
  )
}

export default Greeter
