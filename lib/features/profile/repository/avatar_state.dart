import 'package:flutter/material.dart';
import 'package:sweater/features/profile/model/avatar.dart';

    
class AvatarState {
    final Avatar avatar;
    final bool isLoading;

    AvatarState({
        required this.avatar, 
        this.isLoading = false
    });

    AvatarState copyWith({
        Avatar? avatar,
        bool? isLoading,
    }) {
        return AvatarState(
            avatar: avatar ?? this.avatar,
            isLoading: isLoading ?? this.isLoading,
        );
    }
}