extends Node2D

var score := [0, 0] # Player, CPU

func _on_ball_timer_timeout():
  $Ball.new_ball()

func _on_score_left_body_entered(_body):
  score[1] += 1
  $Hud/CPUScore.text = str(score[1])
  $BallTimer.start()

func _on_score_right_body_entered(_body):
  score[0] += 1
  $Hud/PlayerScore.text = str(score[0])
  $BallTimer.start()