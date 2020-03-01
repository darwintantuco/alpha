import React from 'react'

const Greeter = ({ message }) => {
  return (
    <div data-testid='greeter'>{message} - from Greeter react component</div>
  )
}

export default Greeter
